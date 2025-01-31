{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, vte, gtk3, ncurses, pcre2, wrapGAppsHook3, nixosTests }:

let

  # termite requires VTE with some internals exposed
  # https://github.com/thestinger/vte-ng
  #
  # three of the patches have been locally modified to cleanly apply on 0.62
  vte-ng =  vte.overrideAttrs (attrs: {
    patches = attrs.patches or [] ++ [
      (fetchpatch {
        name = "0001-expose-functions-for-pausing-unpausing-output.patch";
        url = "https://github.com/thestinger/vte-ng/commit/342e26574f50dcd40bbeaad9e839c2a6144d0c1c.patch";
        sha256 = "1b0k9ys545q85vfki417p21kis9f36yd0hyp12phayynss6fn715";
      })
      # Derived from https://github.com/thestinger/vte-ng/commit/5ae3acb69474fe5bc43767a4a3625e9ed23607a1.patch
      ./vte-ng-modified-patches/vte-0002-expose-function-for-setting-cursor-position.patch
      # Derived from https://github.com/thestinger/vte-ng/commit/742d57ecf15e24f6a5f2133a81b6c70acc8ff03c.patch
      ./vte-ng-modified-patches/vte-0003-add-function-for-setting-the-text-selections.patch
      (fetchpatch {
        name = "0004-add-functions-to-get-set-block-selection-mode.patch";
        url = "https://github.com/thestinger/vte-ng/commit/08748fd9cb82bd191e5c476b1682ca71f7732572.patch";
        sha256 = "1cnhd8f7ywdgcyd6xmcd2nn39jjxzkxp4d0zsj2k7m5v74nhcs1g";
      })
      # Derived from "https://github.com/thestinger/vte-ng/commit/dd74ae7c06e8888af2fc090ac6f8920a9d8227fb.patch";
      ./vte-ng-modified-patches/vte-0005-expose-function-for-getting-the-selected-text.patch
    ];
  });

in stdenv.mkDerivation rec {
  pname = "termite";
  version = "15";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "termite";
    rev = "v${version}";
    sha256 = "0hp1x6lj098m3jgna274wv5dv60lnzg22297di68g4hw9djjyd2k";
    fetchSubmodules = true;
  };

  # https://github.com/thestinger/termite/pull/516
  patches = [ ./url_regexp_trailing.patch ./add_errno_header.patch
    # Fix off-by-one in select_text() on libvte >= 0.55.0
    # Expected to be included in next release (16).
    (fetchpatch {
      url = "https://github.com/thestinger/termite/commit/7e9a93b421b9596f8980645a46ac2ad5468dac06.patch";
      sha256 = "0vph2m5919f7w1xnc8i6z0j44clsm1chxkfg7l71nahxyfw5yh4j";
    })
  ] ++ lib.optional stdenv.hostPlatform.isDarwin ./remove_ldflags_macos.patch;

  makeFlags = [ "VERSION=v${version}" "PREFIX=" "DESTDIR=$(out)" ];

  buildInputs = [ vte-ng gtk3 ncurses pcre2 ];

  nativeBuildInputs = [ wrapGAppsHook3 pkg-config ];

  outputs = [ "out" "terminfo" ];

  passthru = {
    inherit vte-ng;
    tests = nixosTests.terminal-emulators.termite;
  };

  postInstall = ''
    mkdir -p $terminfo/share
    mv $out/share/terminfo $terminfo/share/terminfo

    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with lib; {
    description = "Simple VTE-based terminal";
    license = licenses.lgpl2Plus;
    homepage = "https://github.com/thestinger/termite/";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.all;
    mainProgram = "termite";
  };
}
