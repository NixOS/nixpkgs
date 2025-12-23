{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  makeBinaryWrapper,
  installShellFiles,
  fortuneAlias ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "fortune-kind";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "cafkafk";
    repo = "fortune-kind";
    rev = "v${version}";
    hash = "sha256-Tpg0Jq2EhkwQuz5ZOtv6Rb5YESSlmzLoJPTxYJNNgac=";
  };

  cargoHash = "sha256-Kp3pv9amEz9oFMDhz0IZDmhpsok5VgrvJZfwSPyz2X0=";

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  buildNoDefaultFeatures = true;

  MAN_OUT = "./man";

  preBuild = ''
    mkdir -p "./$MAN_OUT";
  '';

  preInstall = ''
    installManPage man/fortune-kind.1
    installShellCompletion \
      --fish man/fortune-kind.fish \
      --bash man/fortune-kind.bash \
      --zsh  man/_fortune-kind
    mkdir -p $out
    cp -r $src/fortunes $out/fortunes;
  '';

  postInstall = ''
    wrapProgram $out/bin/fortune-kind \
      --set-default FORTUNE_DIR "$out/fortunes"
  ''
  + lib.optionalString fortuneAlias ''
    ln -s fortune-kind $out/bin/fortune
  '';

  meta = {
    description = "Kinder, curated fortune, written in rust";
    longDescription = ''
      Historically, contributions to fortune-mod have had a less-than ideal
      quality control process, and as such, many of the fortunes that a user may
      receive from the program read more like cryptic inside jokes, or at the
      very worst, locker-room banter. One of the major goals of fortune-kind is
      defining and applying a somewhat more rigorous moderation and editing
      process to the fortune adoption workflow.
    '';
    homepage = "https://github.com/cafkafk/fortune-kind";
    changelog = "https://github.com/cafkafk/fortune-kind/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "fortune-kind";
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
