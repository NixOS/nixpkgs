{ callPackage
}:

{
  idea-community = callPackage ./build.nix {
    version = "2024.3.1";
    buildNumber = "243.22562.145";
    buildType = "idea";
    ideaHash = "sha256-So55gxse7TU05F2c1pe/2BPjZ6xNlCi0Lhaxm+45w/M=";
    androidHash = "sha256-2ZLTh3mwrIWOqn1UHqAVibG5JvfvxinqDna/EGxd0Ds=";
    jpsHash = "sha256-p3AEHULhVECIicyhCYNkxeQoMAorrbvoIj7jcqxYD2s=";
    restarterHash = "sha256-m6HK4kxtAlN6EaszI/xpkVYDaY8W3Qn9FGWgvaW/UYI=";
    mvnDeps = ./idea_maven_artefacts.json;
  };
  pycharm-community = callPackage ./build.nix {
    version = "2024.3";
    buildNumber = "243.21565.199";
    buildType = "pycharm";
    ideaHash = "sha256-NohKF30k3aSYgDUPKrhE2CZmjzT8TK0zw++0Low1OfM=";
    androidHash = "sha256-H1JegxX6sj7XG0EdZhtzL92GupCCoIq4akgK9t06nXM=";
    jpsHash = "sha256-p3AEHULhVECIicyhCYNkxeQoMAorrbvoIj7jcqxYD2s=";
    restarterHash = "sha256-CnTYpYx6SoT6XaS79cm0QpIijIiPKpFh4LfiPJkByXA=";
    mvnDeps = ./pycharm_maven_artefacts.json;
  };
}
