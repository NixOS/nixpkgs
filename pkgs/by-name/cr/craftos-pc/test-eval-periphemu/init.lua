local function assert(cond1, cond2)
    if not cond1 == cond2 then print("FAIL") end
end

local function driveTests()
    periphemu.create("left", "drive")
    local p = peripheral.wrap("left")

    assert(p.isDiskPresent(), false)
    p.insertDisk(649)
    assert(p.isDiskPresent(), true)
    assert(p.getDiskID(), 649)
    assert(p.getDiskLabel(), nil)
end

driveTests()

shell.run("shutdown")
