//! Deterministic, immutable lexical index. No stemming or language model.
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Document {
    pub id: String,
    pub text: String,
}

/// Equal-weight RRF, one contribution per ID per ranker, one-based ranks.
/// A failed ranker is omitted. If both fail, return an error, not an empty success.
pub fn reciprocal_rank_fusion(
    lexical: Result<Vec<String>, String>,
    dense: Result<Vec<String>, String>,
    rank_constant: u32,
    k: usize,
) -> Result<Vec<Hit>, String> {
    if lexical.is_err() && dense.is_err() {
        return Err("both retrieval rankers failed".into());
    }
    let mut scores = BTreeMap::<String, f64>::new();
    let mut first_rank = BTreeMap::<String, usize>::new();
    for ranking in [lexical, dense].into_iter().flatten() {
        let mut seen = BTreeSet::new();
        for id in ranking {
            if seen.insert(id.clone()) {
                let rank = seen.len();
                *scores.entry(id.clone()).or_default() +=
                    1.0 / (f64::from(rank_constant) + rank as f64);
                first_rank
                    .entry(id)
                    .and_modify(|r| *r = (*r).min(rank))
                    .or_insert(rank);
            }
        }
    }
    let mut hits: Vec<_> = scores
        .into_iter()
        .map(|(id, score)| Hit { id, score })
        .collect();
    hits.sort_by(|a, b| {
        b.score
            .total_cmp(&a.score)
            .then_with(|| first_rank[&a.id].cmp(&first_rank[&b.id]))
            .then_with(|| a.id.cmp(&b.id))
    });
    hits.truncate(k);
    Ok(hits)
}

pub struct HybridRetriever {
    pub lexical: Bm25Index,
    rank_constant: u32,
    candidate_limit: usize,
}

pub trait Reranker: Send + Sync {
    fn rerank(&self, query: &str, hits: Vec<Hit>, index: &Bm25Index) -> Result<Vec<Hit>, String>;
}

/// Query-token coverage heuristic, not a cross-encoder or semantic verifier.
/// Stable ties preserve fused order; scores remain RRF scores.
pub struct OverlapReranker;
impl Reranker for OverlapReranker {
    fn rerank(&self, query: &str, hits: Vec<Hit>, index: &Bm25Index) -> Result<Vec<Hit>, String> {
        let terms: BTreeSet<_> = tokenize(query).into_iter().collect();
        let mut scored = Vec::with_capacity(hits.len());
        for hit in hits {
            let document = index
                .document(&hit.id)
                .ok_or("reranker received unknown document")?;
            let tokens: BTreeSet<_> = tokenize(&document.text).into_iter().collect();
            let overlap = terms.intersection(&tokens).count();
            scored.push((hit, overlap));
        }
        scored.sort_by_key(|entry| std::cmp::Reverse(entry.1));
        Ok(scored.into_iter().map(|(hit, _)| hit).collect())
    }
}

impl HybridRetriever {
    pub fn new(
        lexical: Bm25Index,
        rank_constant: u32,
        candidate_limit: usize,
    ) -> Result<Self, String> {
        if !(1..=1024).contains(&candidate_limit) {
            return Err("candidate limit must be 1..=1024".into());
        }
        Ok(Self {
            lexical,
            rank_constant,
            candidate_limit,
        })
    }
    pub fn candidate_limit(&self) -> usize {
        self.candidate_limit
    }
    pub fn retrieve(
        &self,
        query: &str,
        dense: Result<Vec<String>, String>,
    ) -> Result<Vec<Hit>, String> {
        if let Ok(ids) = &dense {
            if ids.iter().any(|id| self.lexical.document(id).is_none()) {
                return Err("dense result is outside invariant snapshot".into());
            }
        }
        let lexical = self
            .lexical
            .search(query, self.candidate_limit)
            .into_iter()
            .map(|hit| hit.id)
            .collect();
        reciprocal_rank_fusion(Ok(lexical), dense, self.rank_constant, self.candidate_limit)
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct Hit {
    pub id: String,
    pub score: f64,
}

/// Unicode alphanumeric runs, lowercased; accents are preserved.
pub fn tokenize(text: &str) -> Vec<String> {
    text.split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .map(str::to_lowercase)
        .collect()
}

pub struct Bm25Index {
    documents: BTreeMap<String, Document>,
    postings: BTreeMap<String, Vec<(String, usize)>>,
    lengths: BTreeMap<String, usize>,
    average_length: f64,
    k1: f64,
    b: f64,
}

impl Bm25Index {
    pub fn new(documents: Vec<Document>, k1: f64, b: f64) -> Result<Self, String> {
        if !k1.is_finite() || k1 <= 0.0 || !b.is_finite() || !(0.0..=1.0).contains(&b) {
            return Err("BM25 requires finite k1 > 0 and 0 <= b <= 1".into());
        }
        let mut index = Self {
            documents: BTreeMap::new(),
            postings: BTreeMap::new(),
            lengths: BTreeMap::new(),
            average_length: 0.0,
            k1,
            b,
        };
        for document in documents {
            if document.id.trim().is_empty() || index.documents.contains_key(&document.id) {
                return Err("empty or duplicate document ID".into());
            }
            let tokens = tokenize(&document.text);
            index.lengths.insert(document.id.clone(), tokens.len());
            let mut frequencies = BTreeMap::new();
            for token in tokens {
                *frequencies.entry(token).or_insert(0usize) += 1;
            }
            for (term, frequency) in frequencies {
                index
                    .postings
                    .entry(term)
                    .or_default()
                    .push((document.id.clone(), frequency));
            }
            index.documents.insert(document.id.clone(), document);
        }
        if !index.documents.is_empty() {
            index.average_length =
                index.lengths.values().sum::<usize>() as f64 / index.documents.len() as f64;
        }
        Ok(index)
    }

    pub fn document(&self, id: &str) -> Option<&Document> {
        self.documents.get(id)
    }
    pub fn documents(&self) -> impl Iterator<Item = &Document> {
        self.documents.values()
    }

    /// Positive Robertson IDF: ln(1 + (N - df + .5)/(df + .5)).
    /// Repeated query terms contribute once. Zero-match documents are omitted.
    pub fn search(&self, query: &str, k: usize) -> Vec<Hit> {
        if k == 0 || self.average_length == 0.0 {
            return Vec::new();
        }
        let mut scores = BTreeMap::<String, f64>::new();
        for term in tokenize(query).into_iter().collect::<BTreeSet<_>>() {
            if let Some(postings) = self.postings.get(&term) {
                let df = postings.len() as f64;
                let idf = (1.0 + (self.documents.len() as f64 - df + 0.5) / (df + 0.5)).ln();
                for (id, tf) in postings {
                    let tf = *tf as f64;
                    let norm =
                        1.0 - self.b + self.b * self.lengths[id] as f64 / self.average_length;
                    // Equivalent forms avoid overflow for very large k1 and
                    // reciprocal overflow for tiny positive k1.
                    let weight = if self.k1 >= 1.0 {
                        (1.0 + 1.0 / self.k1) / (1.0 / self.k1 + norm / tf)
                    } else {
                        tf * (self.k1 + 1.0) / (tf + self.k1 * norm)
                    };
                    *scores.entry(id.clone()).or_default() += idf * weight;
                }
            }
        }
        let mut hits: Vec<_> = scores
            .into_iter()
            .map(|(id, score)| Hit { id, score })
            .collect();
        hits.sort_by(|a, b| b.score.total_cmp(&a.score).then_with(|| a.id.cmp(&b.id)));
        hits.truncate(k);
        hits
    }
}
