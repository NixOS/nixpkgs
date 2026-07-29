local data = loadfile()()
local json = require"json".encode(data)
io.write(json)
