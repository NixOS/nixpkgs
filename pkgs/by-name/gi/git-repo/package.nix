{
  lib,
  stdenv,
  fetchFromGitiles,
  makeWrapper,
  python3,
  git,
  gnupg,
  less,
  openssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-repo";
  version = "2.65";

  src = fetchFromGitiles {
    url = "https://android.googlesource.com/tools/repo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ToJj5WS74vwCAX53UB5zgy1K54y1gNK+1d4qQLmp1L8=";
  };

  # Fix 'NameError: name 'ssl' is not defined'
  patches = [ ./import-ssl-module.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace repo --replace \
      'urllib.request.urlopen(url)' \
      'urllib.request.urlopen(url, context=ssl.create_default_context())'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp repo $out/bin/repo

    runHook postInstall
  '';

  # Important runtime dependencies
  postFixup = ''
    wrapProgram $out/bin/repo --prefix PATH ":" \
      "${
        lib.makeBinPath [
          git
          gnupg
          less
          openssh
        ]
      }"
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Android's repo management tool";
    longDescription = ''
      Repo is a Python script based on Git that helps manage many Git
      repositories, does the uploads to revision control systems, and automates
      parts of the development workflow. Repo is not meant to replace Git, only
      to make it easier to work with Git.
    '';
    homepage = "https://android.googlesource.com/tools/repo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      otavio
      ungeskriptet
    ];
    platforms = lib.platforms.unix;
    mainProgram = "repo";
  };
})
