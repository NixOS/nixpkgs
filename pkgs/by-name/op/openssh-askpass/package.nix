{
  lib,
  stdenv,
  openssh,
  gtk3,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openssh-askpass";
  inherit (openssh) src version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  sourceRoot = "${openssh.pname}-${finalAttrs.version}/contrib";
  makeFlags = "gnome-ssh-askpass3";
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec
    cp -a gnome-ssh-askpass3 $out/libexec/gtk-ssh-askpass
    runHook postInstall
  '';

  meta = {
    description = "A passphrase dialog for OpenSSH and GTK";
    homepage = "https://www.openssh.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ n3tshift ];
  };
})
