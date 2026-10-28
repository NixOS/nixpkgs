{
  discord,
  ...
}@args:

discord.override ({ pname = "discord-canary"; } // removeAttrs args [ "discord" ])
