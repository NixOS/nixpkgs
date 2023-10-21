- `security.sudo.extraRules` now includes `root`'s default rule, with ordering
  priority 400. This is functionally identical for users not specifying rule
  order, or relying on `mkBefore` and `mkAfter`, but may impact users calling
  `mkOrder n` with n ≤ 400.
