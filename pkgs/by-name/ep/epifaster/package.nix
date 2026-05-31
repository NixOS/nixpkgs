{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  __structuredAttrs = true;
  pname = "epifaster";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "EpiSDK";
    repo = "EpiFaster";
    rev = "v${version}";
    hash = "sha256-klTqsW6pzrlxoRhh/4DoVtMYEOkt62Hu+o4SKobJAV4=";
  };

  cargoHash = "sha256-LoSEGRgS/AuGk2KCEZKqDskPm083Jj59OtBShvBWxtQ=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace '".local/lib/epiclang/plugins"' '"${placeholder "out"}/lib/epiclang/plugins"'
  '';

  postInstall = ''
    if ls $src/plugins/*.so 2>/dev/null; then
      mkdir -p $out/lib/epifaster/plugins
      cp $src/plugins/*.so $out/lib/epifaster/plugins/
    fi
  '';

  meta = {
    description = "Rewrite and optimization of Epiclang, ~57% faster";
    homepage = "https://github.com/EpiSDK/EpiFaster";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukas-sgx ];
    mainProgram = "epiclang";
    platforms = lib.platforms.all;
  };
}
