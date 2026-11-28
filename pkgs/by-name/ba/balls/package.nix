{
  lib,
  stdenv,
  buildNimPackage,
  fetchFromGitHub,
  fetchzip,
  nim,
  makeWrapper,
}:

let
  insideout-src = fetchzip {
    url = "https://github.com/disruptek/insideout/archive/7c8f2730df0c4efad1b18cd12f967dc823543aa0.tar.gz";
    sha256 = "0akfhi59vmy9sqwx508p3d6bfx7px5aqmb4qzhb48f5b9klp7vvz";
  };
  # insideout exports posix signals to be compile time constats, but in nim they are not on aarch64
  insideout-patched = stdenv.mkDerivation {
    name = "insideout-patched";
    src = insideout-src;
    dontBuild = true;
    dontConfigure = true;
    installPhase = ''
            mkdir -p $out
            cp -r * $out/
            substituteInPlace $out/insideout/futexes.nim \
              --replace 'import std/posix' \
                        'import std/posix
      when compiles((const x = posix.EINTR)):
        const EINTR = posix.EINTR
      else:
        const EINTR = cint(4)
      when compiles((const x = posix.EAGAIN)):
        const EAGAIN = posix.EAGAIN
      else:
        const EAGAIN = cint(11)
      when compiles((const x = posix.ETIMEDOUT)):
        const ETIMEDOUT = posix.ETIMEDOUT
      else:
        const ETIMEDOUT = cint(110)'

            substituteInPlace $out/insideout/mailboxes.nim \
              --replace 'import std/posix' \
                        'import std/posix
      when compiles((const x = posix.EINTR)):
        const EINTR = posix.EINTR
      else:
        const EINTR = cint(4)'

            substituteInPlace $out/insideout/runtimes.nim \
              --replace 'import std/posix' \
                        'import std/posix
      when compiles((const x = posix.EINTR)):
        const EINTR = posix.EINTR
      else:
        const EINTR = cint(4)
      when compiles((const x = posix.EAGAIN)):
        const EAGAIN = posix.EAGAIN
      else:
        const EAGAIN = cint(11)
      when compiles((const x = posix.ETIMEDOUT)):
        const ETIMEDOUT = posix.ETIMEDOUT
      else:
        const ETIMEDOUT = cint(110)
      when compiles((const x = posix.SIGINT)):
        const SIGINT = posix.SIGINT
      else:
        const SIGINT = cint(2)
      when compiles((const x = posix.SIGTERM)):
        const SIGTERM = posix.SIGTERM
      else:
        const SIGTERM = cint(15)
      when compiles((const x = posix.SIGQUIT)):
        const SIGQUIT = posix.SIGQUIT
      else:
        const SIGQUIT = cint(3)
      when compiles((const x = posix.SIGCONT)):
        const SIGCONT = posix.SIGCONT
      else:
        const SIGCONT = cint(18)'
    '';
  };

  lockAttrs = builtins.fromJSON (builtins.readFile ./lock.json);

  dependencies = map (
    dep:
    let
      fod =
        if (builtins.elem "insideout" dep.packages) then
          insideout-patched
        else
          fetchzip {
            url = dep.url;
            sha256 = dep.sha256;
          };
      srcDir = if dep ? srcDir && dep.srcDir != "" then "/${dep.srcDir}" else "";
    in
    "--path:${fod}${srcDir}"
  ) lockAttrs.depends;
in
buildNimPackage (finalAttrs: {
  pname = "balls";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "disruptek";
    repo = "balls";
    rev = finalAttrs.version;
    hash = "sha256-YmP4ODQwvvQ74+LLnQGkYOnFP7ONjUP6RONRpEgZl2k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  nimFlags = dependencies;

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

  postFixup = ''
    wrapProgram $out/bin/balls \
      --suffix PATH : ${lib.makeBinPath [ nim ]} \
      --append-flags "${lib.escapeShellArgs finalAttrs.nimFlags} --path:${finalAttrs.src}"
  '';

  meta = finalAttrs.src.meta // {
    description = "Testing framework with balls";
    homepage = "https://github.com/disruptek/balls";
    mainProgram = "balls";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
