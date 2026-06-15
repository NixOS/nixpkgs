{
  foks,
}:
foks.overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "${foks.pname}-server";
    subPackages = [ "server/foks-server" ];

    postPatch = ''
      cd ./server/web/templates
      templ generate
      cd -
    '';

    postInstall = ''
      ln -s $out/bin/{foks-server,git-remote-foks}
    '';

    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [
      foks.passthru.templ
      foks
    ];
  }
)
