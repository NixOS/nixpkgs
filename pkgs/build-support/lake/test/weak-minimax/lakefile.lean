import Lake
open Lake DSL

package weakMinimax

require "leanprover-community" / "mathlib" @ git "main"

@[default_target] lean_lib WeakMinimax
