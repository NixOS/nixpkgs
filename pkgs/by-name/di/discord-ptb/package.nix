{
  discord,
  ...
}@args:

discord.override ({ pname = "discord-ptb"; } // removeAttrs args [ "discord" ])
