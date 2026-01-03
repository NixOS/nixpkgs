# Taken from:
# https://about.gitlab.com/2017/03/20/gitlab-8-dot-17-dot-4-security-release/

# lib/tasks/reset_token.rake
require_relative '../../app/models/concerns/token_authenticatable.rb'

STDOUT.sync = true

namespace :tokens do
  desc "Reset all GitLab user auth tokens"
  task reset_all: :environment do
    reset_all_users_token(:reset_authentication_token!)
  end

  desc "Reset all GitLab email tokens"
  task reset_all_email: :environment do
    reset_all_users_token(:reset_incoming_email_token!)
  end

  def reset_all_users_token(token)
    TmpUser.find_in_batches do |batch|
      puts "Processing batch starting with user ID: #{batch.first.id}"

      batch.each(&token)
    end
  end
end

class TmpUser < ActiveRecord::Base
  include TokenAuthenticatable

  self.table_name = 'users'

  def reset_authentication_token!
    write_new_token(:authentication_token)
    save!(validate: false)
  end

  def reset_incoming_email_token!
    write_new_token(:incoming_email_token)
    save!(validate: false)
  end
end
