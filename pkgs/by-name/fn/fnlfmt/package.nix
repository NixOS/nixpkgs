{
  lib,
  stdenv,
  fetchFromSourcehut,
  lua,
  luaPackages,
}:

stdenv.mkDerivation rec {
  pname = "fnlfmt";
  version = "0.3.2";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = "fnlfmt";
    rev = "refs/tags/${version}";
    hash = "sha256-LYHhKC8iA4N8DdCH8GfSOkN/e+W3YjkFhVSDQraKoFk=";
  };

  nativeBuildInputs = [ luaPackages.fennel ];

  buildInputs = [ lua ];

  makeFlags = [
    "PREFIX=$(out)"
    "FENNEL=${luaPackages.fennel}/bin/fennel"
  ];
  sourceRoot = [ "${src.name}/tags/${version}" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/fnlfmt --help > /dev/null

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Formatter for Fennel";
    homepage = src.meta.homepage;
    changelog = "${src.meta.homepage}/tree/${version}/changelog.md";
    license = licenses.mit;
    platforms = lua.meta.platforms;
    maintainers = with maintainers; [ chiroptical ];
    mainProgram = "fnlfmt";
  };
}
