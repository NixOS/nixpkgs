{
  lib,
  fetchFromGitLab,
  beamPackages,
  fetchHex,
  fetchFromGitHub,
}:

beamPackages.mixRelease rec {
  pname = "kazarma";
  version = "1.0.0-alpha.1-2025-06-30";

  src = fetchFromGitLab {
    owner = "technostructures/kazarma";
    repo = "kazarma";
    rev = "2cd1ca80d3c54e54a11fd3b9079f6c4fa6330302";
    hash = "";
  };

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = final: prev: {
      # needs a patch to compile correctly
      cobertura_cover = beamPackages.buildMix rec {
        name = "cobertura_cover";
        version = "0.9.0";

        src = fetchHex {
          pkg = "cobertura_cover";
          version = "${version}";
          sha256 = "870bc4658cacc5c80d13f1206b688925234d2dc4e00278e8a3e72fbbd6bea0b1";
        };

        postPatch = ''
          substituteInPlace ./mix.exs \
            --replace-fail 'description,' '"desc",' \
            --replace-fail 'package,' '"package",'
        '';

        beamDeps = [];
      };
      # mix2nix doesn't support git fetchers unfortunately
      arrows = beamPackages.buildMix {
        name = "arrows";
        version = "0.2.1";

        src = fetchFromGitHub {
          owner = "bonfire-networks";
          repo = "arrows";
          rev = "03aae6fcdfb76bbf5bcd024d17067c5e85c67e34";
          hash = "";
        };
        beamDeps = [ ];
      };
      plug_http_validator = beamPackages.buildMix {
        name = "plug_http_validator";
        version = "0.1.0";

        src = fetchFromGitHub {
          owner = "bonfire-networks";
          repo = "plug_http_validator";
          rev = "dff396fa4dc6c5efb6d95af7897102e3dd235ea1";
          hash = "sha256-LIfmMf5z+yIv2HSIk9maPyPYLS2uKtLy7/vfXLJoWuo=";
        };
        beamDeps = with final; [ dialyxir ex_doc plug ];
      };
      pointers_ulid = beamPackages.buildMix {
        name = "needle_ulid";
        version = "0.4.0";

        src = fetchFromGitHub {
          owner = "bonfire-networks";
          repo = "needle_ulid";
          rev = "7d77ef4a3003e8ab32167891612505d78f0e7a87";
          hash = "";
        };
        beamDeps = [ ];
      };
    };
  };

  meta = {
    description = "Matrix bridge to ActivityPub";
    homepage = "https://kazar.ma/";
    downloadPage = "https://gitlab.com/technostructures/kazarma/kazarma";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.linux;
  };
}
