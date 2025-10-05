{ fetchurl }:

{
  c.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.24.1.tar.gz";
    hash = "sha256:25dd4bb3dec770769a407e0fc803f424ce02c494a56ce95fedc525316dcf9b48";
  };
  lua.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.4.0.tar.gz";
    hash = "sha256:b0977aced4a63bb75f26725787e047b8f5f4a092712c840ea7070765d4049559";
  };
  vim.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v0.7.0.tar.gz";
    hash = "sha256:44eabc31127c4feacda19f2a05a5788272128ff561ce01093a8b7a53aadcc7b2";
  };
  vimdoc.src = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v4.0.0.tar.gz";
    hash = "sha256:8096794c0f090b2d74b7bff94548ac1be3285b929ec74f839bd9b3ff4f4c6a0b";
  };
  query.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.6.2.tar.gz";
    hash = "sha256:90682e128d048fbf2a2a17edca947db71e326fa0b3dba4136e041e096538b4eb";
  };
  markdown.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.0.tar.gz";
    hash = "sha256:14c2c948ccf0e9b606eec39b09286c59dddf28307849f71b7ce2b1d1ef06937e";
  };
}
