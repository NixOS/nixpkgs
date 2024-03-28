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
, gnome
, python3
, callPackage
}:
let
  blake3-cr = callPackage ./blake3-cr { };
in
crystal.buildCrystalPackage rec {
  pname = "collision";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-PCC2Ne2kniz4mixfDLwoPwnztZTByCvKUlcZQ61JumI=";
  };

  shardsFile = ./shards.nix;

  patches = [ ./make.patch ];

  # Crystal compiler has a strange issue with OpenSSL. The project will not compile due to
  # main_module:(.text+0x6f0): undefined reference to `SSL_library_init'
  # There is an explanation for this https://danilafe.com/blog/crystal_nix_revisited/
  # Shortly, adding pkg-config to buildInputs along with openssl fixes the issue.
  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
    gobject-introspection
    gi-crystal
  ] ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libadwaita
    openssl
    libxml2
    gnome.nautilus-python
    python3.pkgs.pygobject3
  ];

  buildTargets = ["bindings" "build"];

  preBuild = ''
    ln -s ${blake3-cr} lib/blake3
  '';

  doCheck = false;
  doInstallCheck = false;

  installTargets = ["desktop" "install"];

  postInstall = ''
    install -Dm555 ./nautilus-extension/collision-extension.py -t $out/share/nautilus-python/extensions
  '';

  meta = with lib; {
    description = "Check hashes for your files";
    homepage = "https://github.com/GeopJr/Collision";
    license = licenses.bsd2;
    mainProgram = "collision";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
