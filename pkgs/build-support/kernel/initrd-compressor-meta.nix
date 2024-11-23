rec {
  cat = {
    executable = pkgs: "cat";
    ubootName = "none";
    extension = ".cpio";
  };
  gzip = {
    executable = pkgs: "${pkgs.gzip}/bin/gzip";
    defaultArgs = ["-9n"];
    ubootName = "gzip";
    extension = ".gz";
  };
  bzip2 = {
    executable = pkgs: "${pkgs.bzip2}/bin/bzip2";
    ubootName = "bzip2";
    extension = ".bz2";
  };
  xz = {
    executable = pkgs: "${pkgs.xz}/bin/xz";
    defaultArgs = ["--check=crc32" "--lzma2=dict=512KiB"];
    extension = ".xz";
  };
  lzma = {
    executable = pkgs: "${pkgs.xz}/bin/lzma";
    defaultArgs = ["--check=crc32" "--lzma1=dict=512KiB"];
    ubootName = "lzma";
    extension = ".lzma";
  };
  lz4 = {
    executable = pkgs: "${pkgs.lz4}/bin/lz4";
    defaultArgs = ["-l"];
    ubootName = "lz4";
    extension = ".lz4";
  };
  lzop = {
    executable = pkgs: "${pkgs.lzop}/bin/lzop";
    ubootName = "lzo";
    extension = ".lzo";
  };
  zstd = {
    executable = pkgs: "${pkgs.zstd}/bin/zstd";
    defaultArgs = ["-10"];
    ubootName = "zstd";
    extension = ".zst";
  };
  pigz = gzip // {
    executable = pkgs: "${pkgs.pigz}/bin/pigz";
  };
  pixz = xz // {
    executable = pkgs: "${pkgs.pixz}/bin/pixz";
    defaultArgs = [];
  };
}
