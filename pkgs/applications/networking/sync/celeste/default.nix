{ lib
, stdenv
, rust
, rustPlatform
, fetchFromGitHub
, substituteAll
, fetchpatch
, pkg-config
, wrapGAppsHook4
, cairo
, gdk-pixbuf
, glib
, graphene
, gtk3
, gtk4
, libadwaita
, libappindicator-gtk3
, librclone
, pango
, rclone
}:

let
  # https://github.com/trevyn/librclone/pull/8
  librclone-mismatched-types-patch = fetchpatch {
    name = "use-c_char-to-be-platform-independent.patch";
    url = "https://github.com/trevyn/librclone/commit/91fdf3fa5f5eea0dfd06981ba72e09034974fdad.patch";
    hash = "sha256-8YDyUNP/ISP5jCliT6UCxZ89fdRFud+6u6P29XdPy58=";
  };
in rustPlatform.buildRustPackage rec {
  pname = "celeste";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "hwittenborn";
    repo = "celeste";
    rev = "v${version}";
    hash = "sha256-pFtyfKGPlwum/twGXi/e82BjINy6/MMvvmVfrwWHTQg=";
  };

  cargoHash = "sha256-wcgu4KApkn68Tpk3PQ9Tkxif++/8CmS4f8AOOpCA/X8=";

  patches = [
    (substituteAll {
      src = ./target-dir.patch;
      rustTarget = rust.toRustTarget stdenv.hostPlatform;
    })
  ];

  postPatch = ''
    pushd $cargoDepsCopy/librclone-sys
    oldHash=$(sha256sum build.rs | cut -d " " -f 1)
    patch -p2 < ${./librclone-path.patch}
    substituteInPlace build.rs \
      --subst-var-by librclone ${librclone}
    substituteInPlace .cargo-checksum.json \
      --replace $oldHash $(sha256sum build.rs | cut -d " " -f 1)
    popd
    pushd $cargoDepsCopy/librclone
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    patch -p1 < ${librclone-mismatched-types-patch}
    substituteInPlace .cargo-checksum.json \
      --replace $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
    popd
  '';

  # Cargo.lock is outdated
  preConfigure = ''
    cargo update --offline
  '';

  # We need to build celeste-tray first because celeste/src/launch.rs reads that file at build time.
  # Upstream does the same: https://github.com/hwittenborn/celeste/blob/765dfa2/justfile#L1-L3
  cargoBuildFlags = [ "--bin" "celeste-tray" ];
  postConfigure = ''
    cargoBuildHook
    cargoBuildFlags=
  '';

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    graphene
    gtk3
    gtk4
    libadwaita
    librclone
    pango
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libappindicator-gtk3 ]}"
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  meta = {
    changelog = "https://github.com/hwittenborn/celeste/blob/${src.rev}/CHANGELOG.md";
    description = "GUI file synchronization client that can sync with any cloud provider";
    homepage = "https://github.com/hwittenborn/celeste";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
