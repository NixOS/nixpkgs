{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lqFhLCOLiuSQWhbcZUEj2xFRlZ+x1ZTVc8IJw7tJjhE=";
  };

  cargoHash = "sha256-3hrpg2cMvIuFy6mH1/1igIpU4nbzFQLCAhiIRZbTuaI=";

  # fixes `thread 'main' panicked at 'cannot find strip'` on x86_64-darwin
  env = lib.optionalAttrs (stdenv.isx86_64 && stdenv.isDarwin) {
    TARGET_STRIP = "${stdenv.cc.targetPrefix}strip";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';

  postInstall = ''
    mkdir -p $out/share
    cp assets/desktop/xplr.desktop $out/share

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp assets/icon/xplr.svg $out/share/icons/hicolor/scalable/apps

    for size in 16 32 64 128; do
      icon_dir=$out/share/icons/hicolor/''${size}x$size/apps
      mkdir -p $icon_dir
      cp assets/icon/xplr$size.png $icon_dir/xplr.png
    done
  '';

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    changelog = "https://github.com/sayanarijit/xplr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g mimame figsoda ];
  };
}
