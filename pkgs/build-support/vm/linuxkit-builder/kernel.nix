{ pkgs }:

(pkgs.linuxPackages_custom {
  inherit (pkgs.linux_4_9) src;
  version = "${pkgs.linux_4_9.version}-linuxkit";
  configfile = pkgs.fetchurl {
    url = https://raw.githubusercontent.com/linuxkit/linuxkit/cb1c74977297b326638daeb824983f0a2e13fdf2/kernel/kernel_config-4.9.x-x86_64;
    sha256 = "1lpz2q5mhvq7g5ys2s2zynibbxczqzscxbwxfbhb4mkkpps8dv08";
  };
}).kernel
