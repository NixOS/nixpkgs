{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "6.3.4225";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y+7tRp4JNlefsKnMgU9d3b9pzgBJbSKGI98CzkcOjq8=";
  };

  vendorHash = "sha256-NIhg8D8snCNxpb3i2JG5tLcZteYBCGN4QbOowG/vgJE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    mainProgram = "murex";
    homepage = "https://murex.rocks";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };

  passthru = {
    shellPath = "/bin/murex";
  };
}
