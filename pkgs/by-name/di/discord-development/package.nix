{
  discord,
  ...
}@args:

discord.override ({ pname = "discord-development"; } // removeAttrs args [ "discord" ])
