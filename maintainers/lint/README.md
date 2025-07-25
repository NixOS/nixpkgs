# Nixpkgs Tree-Sitter Linting

This directory contains tree-sitter based linting rules for nixpkgs, powered by [ast-grep](https://ast-grep.github.io/).

## Directory Structure

```
lint/
├── sgconfig.yml       # ast-grep project configuration
├── rules/            # Linting rules by category
│   ├── pkgs/         # Rules for packages
│   ├── general/      # General Nix/nixpkgs rules
│   ├── nixos/        # Rules for NixOS modules
│   └── experimental/ # Rules under development
├── tests/            # Test cases for rules
│   └── <category>/   # Mirrors rules structure
├── utils/            # Reusable YAML rule snippets
└── README.md         # This file
```

## Running the Linter

### Locally
```bash
# Run ast-grep directly on specific files
./maintainers/lint/ast-grep scan <files>

# Run with auto-fix
./maintainers/lint/ast-grep scan --fix <files>

# Run specific rule
./maintainers/lint/ast-grep scan --rule maintainers/lint/rules/pkgs/meta-description-required.yaml <files>
```

### In CI

TODO

## Writing New Rules

### Quick Start
```bash
# Create a new rule using ast-grep's built-in command
./ast-grep new

# Test your rule
./ast-grep test tests/<category>/<rule-name>-test.yaml
```

### Rule Format
Rules are written in YAML using ast-grep's pattern syntax:

```yaml
id: rule-name
language: nix
message: Brief description of the issue
severity: error  # or warning, info
rule:
  pattern: |
    # Tree-sitter pattern to match
note: |
  Detailed explanation and how to fix
metadata:
  category: correctness  # or style, performance, security
```

### Debugging Rules
To understand the AST structure of Nix code, use ast-grep's debug feature:

```bash
# Show the AST structure for a code snippet
ast-grep -p "buildInputs = [ pkg-config ]" -l nix --debug-query=sexp

# Example output:
# (source_code expression: (apply_expression function: (variable_expression name: (identifier)) ...))
```

This helps you write accurate patterns by showing the exact tree-sitter node types and structure.

### Using Utility Rules
Common patterns can be defined in `utils/` and referenced:

```yaml
rule:
  pattern: |
    buildInputs = $LIST
  has:
    metavariable: LIST
    has:
      matches: is-native-build-tool  # References utils/common-patterns.yml
```

### Testing Rules
Create a test file in `tests/<category>/<rule-name>-test.yaml`:

```yaml
id: rule-name
valid:
  - |
    # Code that should NOT trigger the rule
    { }
invalid:
  - |
    # Code that SHOULD trigger the rule
    { }
```

## Contributing

1. Create a new rule in the appropriate category
2. Add comprehensive tests
3. Run `ast-grep test` to verify
4. Submit PR with clear rationale
5. Rules typically start in experimental and graduate after review

## Resources

- [ast-grep documentation](https://ast-grep.github.io/)
- [tree-sitter-nix grammar](https://github.com/nix-community/tree-sitter-nix)
- [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/)
