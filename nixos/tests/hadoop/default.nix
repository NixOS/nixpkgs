{ handleTestOn, package, ... }:

{
  all = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./hadoop.nix {
    inherit package;
  };
  hdfs = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./hdfs.nix {
    inherit package;
  };
  yarn = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./yarn.nix {
    inherit package;
  };
  hbase = handleTestOn [ "x86_64-linux" "aarch64-linux" ] ./hbase.nix {
    inherit package;
  };
}
