pkgs: {
  rocksdb_11_8 = pkgs.callPackage ./package.nix {
    version = "11.8.1";
    hash = "sha256-zjOo0H8/qA879Lcw5wHp2BZzOhl+/wYluxKD9RCfQ+0=";
  };
  rocksdb_9_10 = pkgs.callPackage ./package.nix {
    version = "9.10.0";
    hash = "sha256-G+DlQwEUyd7JOCjS1Hg1cKWmA/qAiK8UpUIKcP+riGQ=";
  };
  rocksdb_8_3 = pkgs.callPackage ./package.nix {
    version = "8.3.2";
    hash = "sha256-mfIRQ8nkUbZ3Bugy3NAvOhcfzFY84J2kBUIUBcQ2/Qg=";
  };
}
