{
  audacious-bare,
  ...
}@args:

audacious-bare.override (
  {
    withPlugins = true;
  }
  // removeAttrs args [ "audacious-bare" ]
)
