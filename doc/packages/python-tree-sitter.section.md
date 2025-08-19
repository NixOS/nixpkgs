# Python Tree Sitter {#python-tree-sitter}

[Tree Sitter](https://tree-sitter.github.io/tree-sitter/) is a framework for building grammars for programming languages. It generates and uses syntax trees from source files, which are useful for code analysis, tooling, and syntax highlighting.

Python bindings for Tree Sitter grammars are provided through the [py-tree-sitter](https://github.com/tree-sitter/py-tree-sitter) module. The Nix package `python3Packages.tree-sitter-grammars` provides pre-built grammars for various languages.

For example, to experiment with the Rust grammar, you can create a shell environment with the following configuration:

```nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "py-tree-sitter-dev-shell";

  buildInputs = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        tree-sitter
        tree-sitter-grammars.tree-sitter-rust
      ]
    ))
  ];
}
```

Once inside the shell, the following Python code demonstrates how to parse a Rust code snippet:

```python
# Import the Tree Sitter library and Rust grammar
import tree_sitter
import tree_sitter_rust

# Load the Rust grammar and initialize the parser
rust = tree_sitter.Language(tree_sitter_rust.language())
parser = tree_sitter.Parser(rust)

# Parse a Rust snippet
tree = parser.parse(
    bytes(
        """
        fn main() {
          println!("Hello, world!");
        }
        """,
        "utf8"
    )
)

# Display the resulting syntax tree
print(tree.root_node)
```

The `tree_sitter_rust.language()` function references the Rust grammar loaded in the Nix shell. The resulting tree allows you to programmatically inspect the structure of the code.

