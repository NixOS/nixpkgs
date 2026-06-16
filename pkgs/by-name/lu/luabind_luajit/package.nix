{
  luabind,
  luajit,
  ...
}@args:

luabind.override (
  {
    lua = luajit;
  }
  // removeAttrs args [
    "luabind"
    "luajit"
  ]
)
