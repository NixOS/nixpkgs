import Mathlib.Order.CompleteLattice.Basic

/-- Weak minimax inequality (weak duality): maximin ≤ minimax.
For any payoff f into a complete lattice, the best worst-case guarantee
for the maximizing player never exceeds the minimax value. -/
theorem weak_minimax {ι κ α : Type*} [CompleteLattice α]
    (f : ι → κ → α) :
    ⨆ i, ⨅ j, f i j ≤ ⨅ j, ⨆ i, f i j :=
  iSup_iInf_le_iInf_iSup f
