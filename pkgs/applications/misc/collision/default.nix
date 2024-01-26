{ stdenv
, lib
, fetchFromGitHub
, crystal
, wrapGAppsHook4
, desktopToDarwinBundle
, gobject-introspection
, libadwaita
, openssl
, libxml2
, pkg-config
, gnome
, python3
}:
crystal.buildCrystalPackage rec {
  pname = "collision";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-Bo/u0UYM/N7tLqdCs2OU5pdj2s9LXPooSR1PCGk9dSc=";
  };

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  # We need to patch makefile because the 'bindings' section executes 'shards install'
  # command, which will fetch github and fail the build. Also we need to manually build
  # 'gi-crystal' because it was installed without postInstall script.
  patches = [ ./make.patch ];

  # Crystal compiler has a strange issue with OpenSSL. The project will not compile due to
  # main_module:(.text+0x6f0): undefined reference to `SSL_library_init'
  # There is an explanation for this https://danilafe.com/blog/crystal_nix_revisited/
  # Shortly, adding pkg-config to buildInputs along with openssl fixes the issue.
  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
    gobject-introspection
  ] ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libadwaita
    openssl
    libxml2
    gnome.nautilus-python
    python3.pkgs.pygobject3
  ];

  buildTargets = ["bindings" "build"];

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
