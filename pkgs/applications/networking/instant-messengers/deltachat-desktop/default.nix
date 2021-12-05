{ lib, copyDesktopItems, electron, esbuild, fetchFromGitHub, fetchpatch
, libdeltachat, makeDesktopItem, makeWrapper, nodePackages, pkg-config
, rustPlatform, stdenv, CoreServices }:

let
  libdeltachat' = libdeltachat.overrideAttrs (old: rec {
    version = "1.60.0";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = version;
      sha256 = "1agm5xyaib4ynmw4mhgmkhh4lnxs91wv0q9i1zfihv2vkckfm2s2";
    };
    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${old.pname}-${version}";
      sha256 = "09d3mw2hb1gmqg7smaqwnfm7izw40znl0h1dz7s2imms2cnkjws1";
    };
    patches = [
      # https://github.com/deltachat/deltachat-core-rust/pull/2589
      (fetchpatch {
        url =
          "https://github.com/deltachat/deltachat-core-rust/commit/408467e85d04fbbfd6bed5908d84d9e995943487.patch";
        sha256 = "1j2ywaazglgl6370js34acrg0wrh0b7krqg05dfjf65n527lzn59";
      })
      ./no-static-lib.patch
      # https://github.com/deltachat/deltachat-core-rust/pull/2660
      (fetchpatch {
        url =
          "https://github.com/deltachat/deltachat-core-rust/commit/8fb5e038a97d8ae68564c885d61b93127a68366d.patch";
        sha256 = "088pzfrrkgfi4646dc72404s3kykcpni7hgkppalwlzg0p4is41x";
      })
    ];
  });
  electronExec = if stdenv.isDarwin then
    "${electron}/Applications/Electron.app/Contents/MacOS/Electron"
  else
    "${electron}/bin/electron";
in nodePackages.deltachat-desktop.override rec {
  pname = "deltachat-desktop";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    sha256 = "0in6w2vl4ypgjb9gfhyh77vg05ni5p3z24lah7wvvhywcpv1jp2n";
  };

  nativeBuildInputs = [ esbuild makeWrapper pkg-config ]
    ++ lib.optionals stdenv.isLinux [ copyDesktopItems ];

  buildInputs = [ libdeltachat' ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  USE_SYSTEM_LIBDELTACHAT = "true";
  VERSION_INFO_GIT_REF = src.rev;

  postInstall = let
    keep = lib.concatMapStringsSep " " (file: "! -name ${file}") [
      "_locales"
      "build"
      "html-dist"
      "images"
      "index.js"
      "node_modules"
      "themes"
      "tsc-dist"
    ];
  in ''
    rm -r node_modules/deltachat-node/{deltachat-core-rust,prebuilds,src}

    patchShebangs node_modules/sass/sass.js

    npm run build

    npm prune --production

    find . -mindepth 1 -maxdepth 1 ${keep} -print0 | xargs -0 rm -r

    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/lib/node_modules/deltachat-desktop/build/icon.png \
      $out/share/icons/hicolor/scalable/apps/deltachat.png

    makeWrapper ${electronExec} $out/bin/deltachat \
      --add-flags $out/lib/node_modules/deltachat-desktop
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    name = "deltachat";
    exec = "deltachat %u";
    icon = "deltachat";
    desktopName = "Delta Chat";
    genericName = "Delta Chat";
    comment = meta.description;
    categories = "Network;InstantMessaging;Chat;";
    extraEntries = ''
      StartupWMClass=DeltaChat
      MimeType=x-scheme-handler/openpgp4fpr;x-scheme-handler/mailto;
    '';
  });

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
