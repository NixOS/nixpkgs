{ symlinkJoin
, nickel
}:

symlinkJoin {
  name = "nls-${nickel.version}";
  pname = "nls";
  inherit (nickel) version;

  paths = [ nickel.nls ];

  meta = {
    inherit (nickel.meta) homepage changelog license maintainers;
    description = "A language server for the Nickel programming language";
    longDescription = ''
      The Nickel Language Server (NLS) is a language server for the Nickel
      programming language. NLS offers error messages, type hints, and
      auto-completion right in your favorite LSP-enabled editor.
    '';
  };
}
