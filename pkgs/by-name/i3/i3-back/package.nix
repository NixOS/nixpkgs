{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  i3-back,
}:
rustPlatform.buildRustPackage rec {
  pname = "i3-back";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "i3-back";
    tag = "v${version}";
    hash = "sha256-xGfX7ttWrcIVhy+MkR5RZr2DCAwIKwGu7zkafHcrjaE=";
  };

  patches = [
    # `let_chain` feature is not needed anymore with 1.90.
    # See https://github.com/Cretezy/i3-back/pull/5
    ./remove-feature.patch
  ];

  cargoHash = "sha256-o/um/Ugm3GfDz1daBKxoDD7ailUu6QJ0rj5jcKWB0lM=";

  passthru.tests.version = testers.testVersion { package = i3-back; };

  meta = {
    description = "i3/Sway utility to switch focus to your last focused window";
    homepage = "https://github.com/Cretezy/i3-back";
    changelog = "https://github.com/Cretezy/i3-back/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gabyx ];
    platforms = lib.platforms.linux;
    mainProgram = "i3-back";
  };
}
