{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  gawk,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lynis";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = "lynis";
    tag = finalAttrs.version;
    hash = "sha256-f1iV9OBkycrwP3ydjaGMX45JIBtzZKHEJqnEoVuZPu4=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
  '';

  installPhase = ''
    install -d $out/bin $out/share/lynis
    install -Dm555 -t $out/libexec lynis
    cp -r include db default.prf plugins $out/share/lynis/
    makeWrapper "$out/libexec/lynis" "$out/bin/lynis" \
      --prefix PATH : ${lib.makeBinPath [ gawk ]}

    installManPage lynis.8
    installShellCompletion --bash --name lynis.bash \
      extras/bash_completion.d/lynis
  '';

  meta = {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    mainProgram = "lynis";
    homepage = "https://cisofy.com/lynis/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ryneeverett ];
  };
})
