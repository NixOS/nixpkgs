{
  lib,
  stdenv,
  fetchFromGitea,
  testers,
  bytefetch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bytefetch";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "devcheckra1n";
    repo = "bytefetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ikTzuu4JxQrASSwGH/FWlzWidTpdEnPeAcrUjmazpCE=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 bytefetch $out/bin/bytefetch
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = bytefetch; };

  meta = {
    description = "Small, fast system information tool";
    longDescription = ''
      bytefetch prints the system information a fetch tool normally shows
      without starting a subprocess, reading everything from sysctl,
      IORegistry, /proc, /sys and getifaddrs and emitting it in a single
      write. The output is configurable through ~/.config/bytefetch/config.
    '';
    homepage = "https://codeberg.org/devcheckra1n/bytefetch";
    license = lib.licenses.gpl3Only;
    mainProgram = "bytefetch";
    maintainers = with lib.maintainers; [ devcheckra1n ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
