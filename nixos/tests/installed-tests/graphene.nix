{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.graphene;
}
