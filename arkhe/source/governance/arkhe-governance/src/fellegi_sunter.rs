//! AKG-ONTO-0002 — Fellegi-Sunter model with EM.
//!
//! Attributes are `(condition, modality)`. ACTION is the blocking key and is
//! excluded: under blocking by action, every training pair agrees on action.
//! A constant attribute carries no intra-block information; smoothing can
//! introduce artificial differences between component estimates.
//! See ADR-0001.

use crate::er_backend::{ComparisonVector, FS_ATTRIBUTES};

#[derive(Debug, Clone)]
pub struct FellegiSunter {
    pub m: [f64; FS_ATTRIBUTES],
    pub u: [f64; FS_ATTRIBUTES],
    pub prior_match_rate: f64,
}

impl FellegiSunter {
    pub fn default_model() -> Self {
        Self {
            // condition: matches tend to agree; non-matches tend to disagree.
            // modality: non-matches may agree by chance more often than condition.
            m: [0.9, 0.9],
            u: [0.1, 0.5],
            prior_match_rate: 0.1,
        }
    }

    pub fn match_probability(&self, v: &ComparisonVector) -> f64 {
        let prior = self.prior_match_rate.clamp(1e-9, 1.0 - 1e-9);
        let mut log_odds = (prior / (1.0 - prior)).ln();
        for a in 0..FS_ATTRIBUTES {
            let m = self.m[a].clamp(1e-9, 1.0 - 1e-9);
            let u = self.u[a].clamp(1e-9, 1.0 - 1e-9);
            if v.gamma[a] == 1 {
                log_odds += (m / u).ln();
            } else {
                log_odds += ((1.0 - m) / (1.0 - u)).ln();
            }
        }
        1.0 / (1.0 + (-log_odds).exp())
    }

    /// Fit via EM on unlabeled comparison vectors.
    /// If `vectors` is empty, the model is unchanged — callers must treat
    /// this as "no evidence" (cold start) and fail closed.
    pub fn fit_em(&mut self, vectors: &[ComparisonVector], max_iter: usize, tol: f64) {
        let n = vectors.len();
        if n == 0 {
            return;
        }
        for _iter in 0..max_iter {
            let post: Vec<f64> = vectors.iter().map(|v| self.match_probability(v)).collect();
            let sum_post: f64 = post.iter().sum();
            let sum_nonmatch: f64 = n as f64 - sum_post;
            if sum_post < 1e-9 || sum_nonmatch < 1e-9 {
                break;
            }
            let mut max_delta = 0.0f64;
            for a in 0..FS_ATTRIBUTES {
                let m_num: f64 = vectors
                    .iter()
                    .enumerate()
                    .filter(|(_, v)| v.gamma[a] == 1)
                    .map(|(i, _)| post[i])
                    .sum();
                let u_num: f64 = vectors
                    .iter()
                    .enumerate()
                    .filter(|(_, v)| v.gamma[a] == 1)
                    .map(|(i, _)| 1.0 - post[i])
                    .sum();
                let new_m = (m_num + 1.0) / (sum_post + 2.0);
                let new_u = (u_num + 1.0) / (sum_nonmatch + 2.0);
                max_delta = max_delta
                    .max((new_m - self.m[a]).abs())
                    .max((new_u - self.u[a]).abs());
                self.m[a] = new_m;
                self.u[a] = new_u;
            }
            let new_prior = ((sum_post + 1.0) / (n as f64 + 2.0)).clamp(1e-3, 1.0 - 1e-3);
            max_delta = max_delta.max((new_prior - self.prior_match_rate).abs());
            self.prior_match_rate = new_prior;
            if max_delta < tol {
                break;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn default_probability_and_empty_training() {
        let mut model = FellegiSunter::default_model();
        let vector = ComparisonVector { gamma: [1, 1] };
        assert!((model.match_probability(&vector) - 9.0 / 14.0).abs() < 1e-12);
        model.fit_em(&[], 50, 1e-4);
        assert_eq!(model.m, [0.9, 0.9]);
        assert_eq!(model.u, [0.1, 0.5]);
        model.prior_match_rate = 0.3;
        assert!((model.match_probability(&vector) - 243.0 / 278.0).abs() < 1e-12);
    }

    #[test]
    fn smoothing_keeps_degenerate_corpora_finite() {
        for gamma in [[0, 0], [1, 1], [1, 0], [0, 1]] {
            let mut model = FellegiSunter::default_model();
            model.fit_em(&vec![ComparisonVector { gamma }; 20], 50, 1e-4);
            for gamma in [[0, 0], [1, 1], [1, 0], [0, 1]] {
                let p = model.match_probability(&ComparisonVector { gamma });
                assert!(p.is_finite() && (0.0..=1.0).contains(&p));
            }
        }
    }
}
