{
  stdenv,
  fetchFromGitHub,
  janet,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spork";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "spork";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-H6QdzMXesedPmyGzq83H9rDxyw61Efv8BOPP+2rmulg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;

  buildInputs = [ janet ];

  dontBuild = true;

  installPhase = ''

    mkdir -p $out

    export JANET_PATH=$out

    janet --install .

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/janet-pm --help
    $out/bin/janet-format --help
    $out/bin/janet-netrepl --help
  '';

  meta = janet.meta // {
    description = "Janet Project Manager for the Janet programming language";
    mainProgram = "janet-pm";
    programs = [
      "janet-pm"
      "janet-format"
      "janet-netrepl"
    ];
  };
})
