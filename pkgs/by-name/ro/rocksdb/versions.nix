pkgs: {
  rocksdb_10_10 = pkgs.callPackage ./package.nix {
    version = "10.10.1";
    hash = "sha256-gszW+YY8ZZ7cRVCIXuahGopqqswNRnagZLUYYmRxzGY=";
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
