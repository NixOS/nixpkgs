use arkhe_rag::retrieval::{reciprocal_rank_fusion, HybridRetriever};
use arkhe_rag::retrieval::{tokenize, Bm25Index, Document};
use arkhe_rag::retrieval::{Hit, OverlapReranker, Reranker};

#[test]
fn overlap_improves_synthetic_mrr_and_ndcg_when_dense_ranks_wrong_pair_first() {
    let index = Bm25Index::new(corpus(), 1.2, 0.75).unwrap();
    let pairs = [
        ("pagamento aprovação", "logs", "pay"),
        ("consentimento exportação", "pay", "export"),
        ("logs evidência", "export", "logs"),
    ];
    let mut before = 0.0;
    let mut after = 0.0;
    let mut ndcg_before = 0.0;
    let mut ndcg_after = 0.0;
    for (query, wrong, relevant) in pairs {
        let hits = vec![
            Hit {
                id: wrong.into(),
                score: 0.02,
            },
            Hit {
                id: relevant.into(),
                score: 0.01,
            },
        ];
        let ranked = OverlapReranker.rerank(query, hits.clone(), &index).unwrap();
        let rank_before = hits.iter().position(|h| h.id == relevant).unwrap() + 1;
        let rank_after = ranked.iter().position(|h| h.id == relevant).unwrap() + 1;
        before += 1.0 / rank_before as f64;
        after += 1.0 / rank_after as f64;
        ndcg_before += 1.0 / ((rank_before + 1) as f64).log2();
        ndcg_after += 1.0 / ((rank_after + 1) as f64).log2();
    }
    assert_eq!(before / 3.0, 0.5);
    assert_eq!(after / 3.0, 1.0);
    assert!(ndcg_after > ndcg_before);
    let hits = vec![
        Hit {
            id: "logs".into(),
            score: 0.01,
        },
        Hit {
            id: "pay".into(),
            score: 0.01,
        },
    ];
    assert_eq!(
        OverlapReranker
            .rerank("unmatched", hits.clone(), &index)
            .unwrap(),
        hits
    );
    assert!(OverlapReranker
        .rerank(
            "x",
            vec![Hit {
                id: "unknown".into(),
                score: 0.0
            }],
            &index
        )
        .is_err());
}

fn ids(values: &[&str]) -> Vec<String> {
    values.iter().map(|s| (*s).into()).collect()
}

#[test]
fn rrf_preserves_surviving_ranker_order_and_rejects_total_failure() {
    for constant in [0, 60] {
        for (a, b) in [
            (Ok(ids(&["z", "a", "b"])), Err("offline".into())),
            (Err("offline".into()), Ok(ids(&["z", "a", "b"]))),
        ] {
            let hits = reciprocal_rank_fusion(a, b, constant, 3).unwrap();
            assert_eq!(
                hits.iter().map(|h| h.id.as_str()).collect::<Vec<_>>(),
                ["z", "a", "b"]
            );
        }
    }
    assert!(reciprocal_rank_fusion(Err("a".into()), Err("b".into()), 60, 3).is_err());
    let hits =
        reciprocal_rank_fusion(Ok(ids(&["a", "a", "b"])), Ok(ids(&["b", "c"])), 60, 3).unwrap();
    assert_eq!(hits[0].id, "b");
    assert!((hits[0].score - (1.0 / 62.0 + 1.0 / 61.0)).abs() < 1e-12);
}

#[test]
fn hybrid_recovers_lexical_hit_and_rejects_unknown_dense_ids() {
    let hybrid =
        HybridRetriever::new(Bm25Index::new(corpus(), 1.2, 0.75).unwrap(), 60, 10).unwrap();
    let hits = hybrid
        .retrieve("pagamento", Ok(ids(&["logs", "pay"])))
        .unwrap();
    assert_eq!(hits[0].id, "pay");
    assert_eq!(
        hybrid
            .retrieve("pagamento", Err("dense offline".into()))
            .unwrap()[0]
            .id,
        "pay"
    );
    assert!(hybrid.retrieve("pagamento", Ok(ids(&["unknown"]))).is_err());
}

fn corpus() -> Vec<Document> {
    [
        ("pay", "pagamento exige aprovação humana"),
        ("export", "exportação exige consentimento explícito"),
        ("logs", "logs devem preservar evidência"),
        ("empty", ""),
    ]
    .into_iter()
    .map(|(id, text)| Document {
        id: id.into(),
        text: text.into(),
    })
    .collect()
}

#[test]
fn bm25_synthetic_recall_at_one_and_tokenization() {
    let index = Bm25Index::new(corpus(), 1.2, 0.75).unwrap();
    let judgments = [
        ("Quem aprova PAGAMENTO?", "pay"),
        ("consentimento para exportação", "export"),
        ("preservar logs", "logs"),
    ];
    let recalled = judgments
        .iter()
        .filter(|(q, relevant)| index.search(q, 1)[0].id == *relevant)
        .count();
    assert_eq!(recalled as f64 / judgments.len() as f64, 1.0);
    assert_eq!(
        tokenize("APROVAÇÃO, humana_42!"),
        ["aprovação", "humana", "42"]
    );
    assert!(index.search("desconhecido", 4).is_empty());
    assert!(index.search("", 4).is_empty());
    assert!(index.search("pagamento", 0).is_empty());
}

#[test]
fn bm25_formula_parameters_and_stable_identity() {
    let docs = vec![
        Document {
            id: "b".into(),
            text: "x x".into(),
        },
        Document {
            id: "a".into(),
            text: "x".into(),
        },
    ];
    let index = Bm25Index::new(docs.clone(), 1.2, 0.0).unwrap();
    for extreme in [f64::MAX, f64::MIN_POSITIVE, f64::from_bits(1)] {
        assert!(Bm25Index::new(docs.clone(), extreme, 0.75)
            .unwrap()
            .search("x", 4)
            .iter()
            .all(|h| h.score.is_finite() && h.score > 0.0));
    }
    let hits = index.search("x x", 4);
    let expected = (1.0_f64 + 0.5 / 2.5).ln() * 2.0 * 2.2 / 3.2;
    assert!((hits[0].score - expected).abs() < 1e-12);
    let mut reverse = docs.clone();
    reverse.reverse();
    assert_eq!(
        hits,
        Bm25Index::new(reverse, 1.2, 0.0).unwrap().search("x", 4)
    );
    for (k1, b) in [
        (0.0, 0.5),
        (f64::NAN, 0.5),
        (1.0, f64::INFINITY),
        (1.0, -0.1),
    ] {
        assert!(Bm25Index::new(docs.clone(), k1, b).is_err());
    }
    assert!(Bm25Index::new(vec![docs[0].clone(), docs[0].clone()], 1.2, 0.75).is_err());
    assert!(Bm25Index::new(vec![], 1.2, 0.75)
        .unwrap()
        .search("x", 1)
        .is_empty());
}
