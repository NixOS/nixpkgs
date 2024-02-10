{ stdenv
, lib
, fetchFromGitHub
, crystal
, wrapGAppsHook4
, desktopToDarwinBundle
, gi-crystal
, gobject-introspection
, libadwaita
, openssl
, libxml2
, pkg-config
}:
crystal.buildCrystalPackage rec {
  pname = "Collision";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-Qxe4ILDdfYfxu95EvKRTvkAOgDIZDiLymBlZouBWn0M=";
  };
  patches = [ ./make.patch ];
  shardsFile = ./shards.nix;

  # Crystal compiler has a strange issue with OpenSSL. The project will not compile due to
  # main_module:(.text+0x6f0): undefined reference to `SSL_library_init'
  # There is an explanation for this https://danilafe.com/blog/crystal_nix_revisited/
  # Shortly, adding pkg-config to buildInputs along with openssl fixes the issue.

  nativeBuildInputs = [ wrapGAppsHook4 pkg-config gobject-introspection gi-crystal ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ libadwaita openssl libxml2 ];

  buildTargets = ["bindings" "build"];

  doCheck = false;
  doInstallCheck = false;

  installTargets = ["desktop" "install"];

  meta = with lib; {
    description = "Check hashes for your files";
    homepage = "https://github.com/GeopJr/Collision";
    license = licenses.bsd2;
    mainProgram = "collision";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
