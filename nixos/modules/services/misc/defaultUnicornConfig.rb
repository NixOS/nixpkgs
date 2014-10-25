worker_processes 2
working_directory ENV["GITLAB_PATH"]
pid ENV["UNICORN_PATH"] + "/tmp/pids/unicorn.pid"

listen ENV["UNICORN_PATH"] + "/tmp/sockets/gitlab.socket", :backlog => 1024
listen "127.0.0.1:8080", :tcp_nopush => true

timeout 60

stderr_path ENV["UNICORN_PATH"] + "/log/unicorn.stderr.log"
stdout_path ENV["UNICORN_PATH"] + "/log/unicorn.stdout.log"

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
