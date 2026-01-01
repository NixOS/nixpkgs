{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  gawk,
  installShellFiles,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "lynis";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = "lynis";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-XMgC6KjkLgjSOBHBx7WM7C2Vm3Z/lto7CFs10kIxwZc=";
=======
    rev = version;
    sha256 = "sha256-f1iV9OBkycrwP3ydjaGMX45JIBtzZKHEJqnEoVuZPu4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
  '';

  installPhase = ''
<<<<<<< HEAD
    install -d $out/bin $out/share/lynis
    install -Dm555 -t $out/libexec lynis
    cp -r include db default.prf plugins $out/share/lynis/
    makeWrapper "$out/libexec/lynis" "$out/bin/lynis" \
      --prefix PATH : ${lib.makeBinPath [ gawk ]}
=======
    install -d $out/bin $out/share/lynis/plugins
    cp -r include db default.prf $out/share/lynis/
    cp -a lynis $out/bin
    wrapProgram "$out/bin/lynis" --prefix PATH : ${lib.makeBinPath [ gawk ]}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    installManPage lynis.8
    installShellCompletion --bash --name lynis.bash \
      extras/bash_completion.d/lynis
  '';

<<<<<<< HEAD
  meta = {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    mainProgram = "lynis";
    homepage = "https://cisofy.com/lynis/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ryneeverett ];
  };
})
=======
  meta = with lib; {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    mainProgram = "lynis";
    homepage = "https://cisofy.com/lynis/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ryneeverett ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
