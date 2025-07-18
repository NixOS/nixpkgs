{
  pkgs,
}:
let
  inherit (pkgs.testers) shellcheck shfmt;
in
{
  write-meta-json = {
    shellcheck = shellcheck {
      name = "write-meta-json";
      src = ./write-meta-json.sh;
    };

    shfmt = shfmt {
      name = "write-meta-json";
      src = ./write-meta-json.sh;
    };
  };
}
