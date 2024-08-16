{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nim,
  makeWrapper,
}:

buildNimPackage (finalAttrs: {
  pname = "balls";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "disruptek";
    repo = "balls";
    rev = finalAttrs.version;
    hash = "sha256-CMYkMkekVI0C1WUds+KBbRfjMte42kBAB2ddtQp8d+k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  lockFile = ./lock.json;

  postPatch =
    # Trim comments from the Nimble file.
    ''
      sed \
        -e 's/[[:space:]]* # .*$//g' \
       -i balls.nimble
    '';

  preCheck = ''
    echo 'path:"$projectDir/.."' > tests/nim.cfg
  '';

  postFixup =
    let
      lockAttrs = builtins.fromJSON (builtins.readFile finalAttrs.lockFile);
      pathFlagOfFod = { path, srcDir, ... }: ''"--path:${path}/${srcDir}"'';
      pathFlags = map pathFlagOfFod lockAttrs.depends;
    in
    ''
      wrapProgram $out/bin/balls \
        --suffix PATH : ${lib.makeBinPath [ nim ]} \
        --append-flags '--path:"${finalAttrs.src}" ${toString pathFlags}'
    '';

  meta = finalAttrs.src.meta // {
    description = "The testing framework with balls";
    homepage = "https://github.com/disruptek/balls";
    mainProgram = "balls";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
