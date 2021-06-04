{ lib
, fetchFromGitLab
, rustPlatform
, pkg-config
, clang
, libclang
, glib
, gtk4
, pipewire
}:

rustPlatform.buildRustPackage rec {
  pname = "helvum";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ryuukyu";
    repo = pname;
    rev = version;
    sha256 = "sha256-sQ4epL3QNOLHuR/dr/amHgiaxV/1SWeb3eijnjAAR3w=";
  };

  cargoSha256 = "sha256-uNTSU06Fz/ud04K40e98rb7o/uAht0DsiJOXeHX72vw=";

  nativeBuildInputs = [ clang pkg-config ];
  buildInputs = [ glib gtk4 pipewire ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  meta = with lib; {
    description = "A GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/ryuukyu/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
  };
}
