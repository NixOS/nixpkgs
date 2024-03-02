{ callPackage
}:

{
  idea-community = callPackage ./build.nix {
    buildVer = "233.13135.103";
    buildType = "idea";
    ideaHash = "sha256-ld6qvc0ceERrLSJOC07JEgDmg3lEYdU/XgjZXgzWTAg=";
    androidHash = "sha256-D8zKkmPOx4RliAtyq2Z8Up2u224blP0SjNjW3yO7nSQ=";
    jpsHash = "sha256-0cmn0N1UVNzw1hNOpy+9HhkHHNq+rVKnfXM+LjHAQ40=";
    restarterHash = "sha256-56GqBY/w8expWTXSP3Bad9u7QV3q8LpNN8nd8tk+Zzk=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
  pycharm-community = callPackage ./build.nix {
    buildVer = "233.13135.95";
    buildType = "pycharm";
    ideaHash = "sha256-avRdwIr+uSXZhcMeamfy7OMYy0Ez7qWljwPc5V6n/60=";
    androidHash = "sha256-D8zKkmPOx4RliAtyq2Z8Up2u224blP0SjNjW3yO7nSQ=";
    jpsHash = "sha256-0cmn0N1UVNzw1hNOpy+9HhkHHNq+rVKnfXM+LjHAQ40=";
    restarterHash = "sha256-YW+5Jl0EWqBj7iRkk70NFL+gccK9/tAOlm/n08XKH8M=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
}
