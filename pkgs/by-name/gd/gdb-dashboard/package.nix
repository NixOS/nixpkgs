{
  lib,
  stdenv,
  fetchFromGitHub,
  gdb,
  makeWrapper,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "gdb-dashboard";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "cyrus-and";
    repo = "gdb-dashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xoBkAFwkbaAsvgPwGwe1JxE1C8gPR6GP1iXeNKK5Z70=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ python3Packages.pygments ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gdb-dashboard
    cp -r .gdbinit $out/share/gdb-dashboard/gdbinit
    makeWrapper ${gdb}/bin/gdb $out/bin/gdb-dashboard \
      --add-flags "-q -x $out/share/gdb-dashboard/gdbinit"

    p=$(toPythonPath ${python3Packages.pygments})
    sed -i "/import os/a import os; import sys; sys.path[0:0] = '$p'.split(':')" \
       $out/share/gdb-dashboard/gdbinit

    runHook postInstall
  '';

  # there are no tests as this is a wrapper

  meta = {
    description = "Modular visual interface for GDB in Python";
    homepage = "https://github.com/cyrus-and/gdb-dashboard";
    downloadPage = "https://github.com/cyrus-and/gdb-dashboard";
    changelog = "https://github.com/cyrus-and/gdb-dashboard/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
