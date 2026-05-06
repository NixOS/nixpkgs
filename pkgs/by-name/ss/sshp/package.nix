{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sshp";
  version = "1.1.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bahamas10";
    repo = "sshp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E7nt+t1CS51YG16371LEPtQxHTJ54Ak+r0LP0erC9Mk=";
  };

  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp sshp $out/bin/

    mkdir -p $man/share/man/man1
    cp man/sshp.1 $man/share/man/man1/
  '';

  meta = {
    description = "Parallel SSH Executor";
    mainProgram = "sshp";
    longDescription = ''
      sshp manages multiple ssh processes and handles coalescing the output to the terminal.
      By default, sshp will read a file of newline-separated hostnames or IPs and fork ssh
      subprocesses for them, redirecting the stdout and stderr streams of the child
      line-by-line to stdout of sshp itself.
    '';
    homepage = "https://github.com/bahamas10/sshp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ theCapypara ];
  };
})
