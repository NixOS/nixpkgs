{
  mercurial,
  ...
}@args:

mercurial.override (
  {
    fullBuild = true;
  }
  // removeAttrs args [ "mercurial" ]
)
