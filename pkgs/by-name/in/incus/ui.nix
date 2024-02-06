{ lxd
, fetchFromGitHub
, git
}:

lxd.ui.overrideAttrs(prev: rec {
  pname = "incus-ui";

  zabbly = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus";
    rev = "141fb0736cc12083b086c389c68c434f86d5749e";
    hash = "sha256-6o1LhqGTpuZNdSVbT8wAVcN5A3CwiXcwVOz0AqDxCPw=";
  };

  nativeBuildInputs = prev.nativeBuildInputs ++ [
    git
  ];

  patchPhase = ''
    for p in $zabbly/patches/ui-canonical*; do
      echo "applying patch $p"
      git apply -p1 "$p"
    done
  '';
})
