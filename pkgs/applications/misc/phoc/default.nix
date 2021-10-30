{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, libinput
, gnome
, glib
, gtk3
, wayland
, libdrm
, libxkbcommon
, wlroots
, runCommand
, patchutils
, fetchurl
}:

let
  # Patchset for upstream MR that gets wlroots to 0.15
  # https://gitlab.gnome.org/World/Phosh/phoc/-/merge_requests/284
  # https://gitlab.gnome.org/World/Phosh/phoc/-/merge_requests/284/diffs?diff_id=255756
  # Not using fetchpatch on purpose here, because we _WANT_ to split it into commits first.
  upstream_wlroots_0_15_patch = fetchurl {
    url = "https://gitlab.gnome.org/World/Phosh/phoc/-/merge_requests/284/diffs.patch?diff_id=255756";
    sha256 = "19pjdrgnr2qpfqql45v8i0sggsvxbrjf1p527m53g0f56cpk4y9z";
    name = "284.patch";
  };
  # Let's horribly maim it using patchitils, grep, and a bit of elbow grease:
  wlroots_0_14_patch = runCommand "wlroots_0_14.patch" {
    nativeBuildInputs = [ patchutils ];
  } ''
    # There might be a nicer way to include only the first 7 commits in this
    # range, but this works.
    csplit --elide-empty-files ${upstream_wlroots_0_15_patch} '/^-- $/' '{*}'
    rm xx07
    cat xx* > first_7.patch

    # We want to use our own wlroots, so the vendored wlroots doesn't exist.
    # Patch complains we claim it does.
    filterdiff \
     --exclude 'a/subprojects/wlroots' first_7.patch \
     > without_vendoring.patch

    # Allow for other wlroots versions.
    sed -i 's@== 0.14.0@== ${wlroots.version}@' without_vendoring.patch

    cat without_vendoring.patch > $out
  '';
in stdenv.mkDerivation rec {
  pname = "phoc";
  version = "0.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    sha256 = "18nwjbyjxq11ppfdky3bnfh9pr23fjl2543jwva0iz1n6c8mkpd9";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    libdrm.dev
    libxkbcommon
    libinput
    glib
    gtk3
    gnome.gnome-desktop
    # For keybindings settings schemas
    gnome.mutter
    wayland
    wlroots
  ];

  mesonFlags = ["-Dembed-wlroots=disabled"];

  patches = [
    wlroots_0_14_patch
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  meta = with lib; {
    description = "Wayland compositor for mobile phones like the Librem 5";
    homepage = "https://gitlab.gnome.org/World/Phosh/phoc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ archseer masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
