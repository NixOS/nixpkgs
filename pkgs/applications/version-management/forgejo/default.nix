{ fetchurl, gitea, lib }:

gitea.overrideAttrs (old: rec {
  pname = "forgejo";
  version = "1.18.0-rc1-1";

  src = fetchurl {
    name = "${pname}-src-${version}.tar.gz";
    url = "https://codeberg.org/attachments/976c426a-3e04-49ff-9762-47fab50624a3";
    hash = "sha256-kreBMHlMVB1UeG67zMbszGrgjaROateCRswH7GrKnEw=";
  };

  postInstall = old.postInstall + ''
    mv $out/bin/{${old.pname},${pname}}
  '';

  meta = with lib; {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/${pname}/${pname}/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
})
