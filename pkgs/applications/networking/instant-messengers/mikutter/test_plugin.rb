# Tests mikutter's event system.

Plugin.create(:test_plugin) do
  require 'logger'
  Delayer.new do
    log = Logger.new(STDOUT)
    log.info("loaded test_plugin")
    exit
  end
end
