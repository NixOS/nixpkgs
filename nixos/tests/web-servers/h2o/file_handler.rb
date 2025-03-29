Proc.new do |env|
  [200, {'content-type' => 'text/plain'}, ["FILE_HANDLER"]]
end
